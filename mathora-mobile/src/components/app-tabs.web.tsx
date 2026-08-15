import {
  Tabs,
  TabList,
  TabTrigger,
  TabSlot,
  TabTriggerSlotProps,
  TabListProps,
} from 'expo-router/ui';
import { Pressable, View, StyleSheet, Text } from 'react-native';

export default function AppTabs() {
  return (
    <View style={styles.pageBackgroundContainer}>
      {/* Sleek Ambient Glow Backdrop */}
      <View style={styles.ambientGlowTop} />
      <View style={styles.ambientGlowBottom} />

      {/* Main Luxury Mobile Phone Frame */}
      <View style={styles.mobilePhoneDevice}>
        {/* Dynamic Island / Speaker Notch Header */}
        <View style={styles.notchHeaderBar}>
          <View style={styles.dynamicIslandNotch}>
            <View style={styles.cameraLens} />
          </View>
          <Text style={styles.deviceTimeText}>9:41</Text>
        </View>

        {/* Mobile Viewport Screen */}
        <Tabs style={styles.mobileViewportTabContainer}>
          <TabSlot style={{ flex: 1, backgroundColor: '#030712' }} />
          <TabList asChild>
            <CustomTabList>
              <TabTrigger name="home" href="/" asChild>
                <TabButton icon="⚡">Home</TabButton>
              </TabTrigger>
              <TabTrigger name="explore" href="/explore" asChild>
                <TabButton icon="📚">Topics</TabButton>
              </TabTrigger>
              <TabTrigger name="squads" href="/squads" asChild>
                <TabButton icon="👥">Squads</TabButton>
              </TabTrigger>
              <TabTrigger name="mock-exam" href="/mock-exam" asChild>
                <TabButton icon="⏱️">Mock</TabButton>
              </TabTrigger>
              <TabTrigger name="settings" href="/settings" asChild>
                <TabButton icon="⚙️">Settings</TabButton>
              </TabTrigger>
            </CustomTabList>
          </TabList>
        </Tabs>

        {/* Smartphone Home Bar Indicator */}
        <View style={styles.bottomHomeBarArea}>
          <View style={styles.homeBarLine} />
        </View>
      </View>
    </View>
  );
}

export function TabButton({ children, icon, isFocused, ...props }: TabTriggerSlotProps & { icon?: string }) {
  return (
    <Pressable {...props} style={({ pressed }) => [styles.tabItemFlex, pressed && styles.pressedTab]}>
      <View style={[styles.tabButtonView, isFocused && styles.tabButtonActive]}>
        <Text style={styles.tabIconEmoji}>{icon}</Text>
        <Text style={[styles.tabLabelText, isFocused && styles.tabLabelTextActive]}>
          {children}
        </Text>
      </View>
    </Pressable>
  );
}

export function CustomTabList(props: TabListProps) {
  return (
    <View {...props} style={styles.tabListWrapper}>
      <View style={styles.glassTabContainer}>
        {props.children}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  pageBackgroundContainer: {
    flex: 1,
    backgroundColor: '#020617',
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 16,
    paddingHorizontal: 12,
    position: 'relative',
  },
  ambientGlowTop: {
    position: 'absolute',
    top: -100,
    left: '25%',
    width: 400,
    height: 400,
    borderRadius: 200,
    backgroundColor: '#4338CA',
    opacity: 0.15,
  },
  ambientGlowBottom: {
    position: 'absolute',
    bottom: -100,
    right: '25%',
    width: 400,
    height: 400,
    borderRadius: 200,
    backgroundColor: '#F59E0B',
    opacity: 0.12,
  },
  mobilePhoneDevice: {
    width: '100%',
    maxWidth: 420,
    height: '100%',
    maxHeight: 880,
    backgroundColor: '#030712',
    borderRadius: 44,
    borderWidth: 10,
    borderColor: '#1E293B',
    overflow: 'hidden',
    shadowColor: '#000000',
    shadowOffset: { width: 0, height: 20 },
    shadowOpacity: 0.95,
    shadowRadius: 30,
    position: 'relative',
  },
  notchHeaderBar: {
    height: 36,
    backgroundColor: '#030712',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 22,
    borderBottomWidth: 1,
    borderColor: '#0F172A',
    zIndex: 10,
  },
  dynamicIslandNotch: {
    width: 80,
    height: 18,
    backgroundColor: '#0F172A',
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    borderColor: '#1E293B',
    borderWidth: 1,
  },
  cameraLens: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: '#020617',
  },
  deviceTimeText: {
    color: '#94A3B8',
    fontSize: 11,
    fontWeight: 'bold',
  },
  mobileViewportTabContainer: {
    flex: 1,
    backgroundColor: '#030712',
  },
  tabListWrapper: {
    width: '100%',
    backgroundColor: '#090D16EE',
    borderTopWidth: 1,
    borderColor: '#1E293B',
    paddingVertical: 8,
    paddingHorizontal: 10,
  },
  glassTabContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    width: '100%',
  },
  tabItemFlex: {
    flex: 1,
    alignItems: 'center',
  },
  pressedTab: {
    opacity: 0.7,
  },
  tabButtonView: {
    alignItems: 'center',
    paddingVertical: 4,
    paddingHorizontal: 10,
    borderRadius: 12,
    backgroundColor: 'transparent',
  },
  tabButtonActive: {
    backgroundColor: '#1E1B4B',
    borderColor: '#4338CA',
    borderWidth: 1,
  },
  tabIconEmoji: {
    fontSize: 16,
  },
  tabLabelText: {
    color: '#64748B',
    fontSize: 10,
    fontWeight: '600',
    marginTop: 2,
  },
  tabLabelTextActive: {
    color: '#F59E0B',
    fontWeight: 'bold',
  },
  bottomHomeBarArea: {
    height: 18,
    backgroundColor: '#030712',
    alignItems: 'center',
    justifyContent: 'center',
  },
  homeBarLine: {
    width: 130,
    height: 4,
    backgroundColor: '#334155',
    borderRadius: 2,
  },
});
